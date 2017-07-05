require "google/cloud/bigquery"

module Agents
  class BigqueryAgent < Agent
    default_schedule '12h'

    description <<-MD
      The Bigquery Agent queries Google BigQuery.

      #{'## Include `google-api-client` in your Gemfile to use this Agent!' if dependencies_missing?}

      This agent relies on service accounts, rather than oauth.
    MD

    def default_options
      {
        'project_id' => '',
        'query' => """SELECT * FROM `project_id.dataset.table` WHERE condition='condition' LIMIT 10""",
        'keyfile' => {
          'private_key' => "{% credential google-bigquery-key %}",
          'client_email' => 'your-service-account-email@project.iam.gserviceaccount.com'
        },
        'use_legacy' => false

        # event_per_row => false
        # 
      }
    end

    def validate_options
      errors.add(:base, "expected_update_period_in_days is required") unless options['expected_update_period_in_days'].present?
    end

    def working?
      event_created_within?(options['expected_update_period_in_days']) && most_recent_event && most_recent_event.payload['success'] == true && !recent_error_logs?
    end

    def google_client
      # https://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-bigquery/v0.26.0/guides/authentication
      # http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-bigquery/v0.26.0/google/cloud/bigquery
      # keyfile can be path or hash

      if interpolated['keyfile'].is_a?(String)
        @bigquery_client ||= Google::Cloud::Bigquery.new(
          project: interpolated['project_id'],
          keyfile: interpolated['keyfile']
        )
      elsif interpolated['keyfile'].is_a?(Hash)
        @bigquery_client ||= Google::Cloud::Bigquery.new(
          project: interpolated['project_id'],
          keyfile: {
            type: "service_account",
            private_key: interpolated['keyfile']['private_key'],
            client_email: interpolated['keyfile']['client_email'] # service_account_email
          }
        )
      end
    end

    def check
      results = google_client.query interpolated['query']
      # max:
      # timeout:
      # legacy_sql: false
      results.each do |row|
        puts row.inspect
      end
      create_event :payload => {
        results: results
      }
    end

#    def receive(incoming_events)
#    end
  end
end
