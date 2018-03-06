# coding: utf-8
require 'octokit'
module Popper::Action
  class Git < Base
    def self.task(mail, params={})
      issue_options = {}
      issue_options[:labels] = @action_config.labels if @action_config.labels

      url = octkit.create_issue(
        @action_config.repo,
        mail.subject,
        mail.utf_body,
        issue_options
      )
      params["#{action_name}_url".to_sym] = url[:html_url] if url
      params
    end

    def self.octkit
      Octokit.reset!
      Octokit::Client.new(:access_token => @action_config.token)
    end

    def self.check_params
      @action_config.respond_to?(:repo) &&
      @action_config.respond_to?(:token)
    end

    next_action(Ghe)
  end
end
