require 'faraday'
require 'faraday_middleware'
require 'pry'
require 'json'

module Teamwork

  VERSION = "1.0.2"

  class API

    def initialize(project_name: nil, api_key: nil)
      @project_name = project_name
      @api_key = api_key
      @api_conn = Faraday.new(url: "http://#{project_name}.teamworkpm.net/") do |c|
        c.request :multipart
        c.request :json
        c.request :url_encoded
        c.response :json, content_type: /\bjson$/
        c.adapter :net_http
      end

      @api_conn.headers[:cache_control] = 'no-cache'
      @api_conn.basic_auth(api_key, '')
    end

    def account(request_params)
      response = @api_conn.get "account.json", request_params
      response.body
    end

    def people(request_params)
      response = @api_conn.get "people.json", request_params
      response.body
    end

    def latestActivity(maxItems: 60, onlyStarred: false)
      request_params = {
        maxItems: maxItems,
        onlyStarred: onlyStarred
      }
      response = @api_conn.get "latestActivity.json", request_params
      response.body
    end

    def get_comment(id)
      response = @api_conn.get "comments/#{id}.json"
      response.body["comment"]
    end

    def get_company_id(name)
      Hash[@api_conn.get('companies.json').body["companies"].map { |c| [c['name'], c['id']] }][name]
    end

    def create_company(name)
      @api_conn.post 'companies.json', { company: { name: name } }
    end

    def get_or_create_company(name)
      create_company(name) if !get_company_id(name)
      get_company_id(name)
    end

    def create_project(name, client_name)
      company_id = get_or_create_company(name)
      @api_conn.post('projects.json', {
          project: {
              name: name,
              companyId: company_id,
              "category-id" => '0'
          }
      }).headers['id']
    end

    def update_project(id, name, client_name)
      company_id = get_or_create_company(name)
      @api_conn.put("projects/#{id}.json", {
          project: {
              name: name,
              companyId: company_id
          }
      }).status
    end

    def delete_project(id)
      @api_conn.delete "projects/#{id}.json"
    end

    def attach_post_to_project(title, body, project_id)
      @api_conn.post "projects/#{project_id}/messsages.json", { post: { title: title, body: body } }
    end
  end
end


