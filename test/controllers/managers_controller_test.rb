require 'test_helper'

class ManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_users_manager_teams      
  end

  # manager_dashboard tests
  test "should redirect manager to manager dashboard" do
    login_as_manager
    get manager_dashboard_url
    assert_response :success
  end
    
  test "should redirect user to login page when trying to access the manager dashboard" do
    login_as_user
    get manager_dashboard_url
    assert_redirected_to login_url
    assert_equal "Please login as a manager to view this site.", flash[:notice] 
  end
  
  # team_health tests
  test "should redirect user to login page when trying to access team health" do
    login_as_user
    get team_health_url (@team)
    assert_redirected_to login_url
    assert_equal "Please login as a manager to view this site.", flash[:notice] 
  end
  
  test "should redirect manager to team health page when they are on the team" do
    login_as_manager
    get team_health_url (@team)
    assert_response :success
  end
    
  test "should redirect manager to manager dashboard when accessing team health page if they are not on that team" do
    login_as_manager
    get team_health_url (@team_no_access)
    assert_redirected_to manager_dashboard_url
    assert_equal "You do not have permission to view this team." , flash[:notice] 
  end

  test "should get new" do
    get new_manager_url
    assert_response :success
  end

  test "should create manager" do
    assert_difference('Manager.count') do
      post managers_url, params: { manager: { flag: "Manager", watiam: "bpark", password: "Password", first_name: "Bob", last_name: "Park"} }
    end
  end

  # tickets tests
  test "manager tickets page should still be successful even if they have no tickets associated to them" do
    login_as_manager
    get team_tickets_url (@team)
    assert_response :success
  end
  
  test "should redirect user to user dashboard page when accessing manager ticket page" do
    login_as_user
    get team_tickets_url (@team)
    assert_redirected_to user_dashboard_url
    assert_equal "You do not have permission to view tickets.", flash[:notice]
  end
    
  test "should log out manager" do
    login_as_manager
    get logout_url
    get manager_dashboard_url
    assert_redirected_to login_url
    assert_equal "Please log in.", flash["notice"]
  end 
end
