require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class XlsExportTest < ActionController::IntegrationTest
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories, :queries,
           :projects_trackers,
           :roles,
           :member_roles,
           :members,
           :enabled_modules,
           :workflows,
           :custom_values

  ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/../fixtures/',
                         [:custom_fields, :custom_fields_projects, :custom_fields_trackers])

  def assert_export_filename(suffix)
    assert_match /attachment; filename=".+_#{suffix}.xls"/, @response.header['Content-Disposition']
  end

  def test_quick_export_is_success
    get '/projects/ecookbook/issues_xls_export_current'
    assert_response :success
    assert_export_filename('issues_export')
  end

  def test_details_export_is_success
    get '/projects/ecookbook/issues_xls_export'
    assert_response :success
    assert_select 'div#settings'

    post '/projects/ecookbook/issues_xls_export'
    assert_response :success
    assert_export_filename('issues_export')
  end

  def test_export_with_cf_which_is_selectable_multi_items
    log_user('jsmith', 'jsmith')

    get '/projects/onlinestore/issues_xls_export_current'
    assert_response :success
    assert_export_filename('issues_export')
  end

end