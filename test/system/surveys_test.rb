require "application_system_test_case"

class SurveysTest < ApplicationSystemTestCase
  setup do
    setup_users_manager_teams
    @team_no_access.users << @user
    @team_no_access.managers << @manager
    @s_1 = Survey.create(team_id: @team.id, user_id: @user.id, date: Date.new(2021,3,13))
    Survey.create(team_id: @team_no_access.id, user_id: @user.id, date: Date.new(2021,3,13))
  end
  
  test "visiting /surveys should send user and manager to respective dashboard" do
    login(@user)
    visit surveys_url
    has_current_path? user_dashboard_path
    visit logout_path
    login(@manager)
    visit surveys_url
    has_current_path? manager_dashboard_path
  end
      
  test "should be able to visit weekly survey page" do
    login(@user)
    click_on "Team 1"
    click_on "Weekly Surveys" 
    assert_text "WEEKLY SURVEYS"
  end
    
  test "should be able to submit a survey" do
    login(@user)
    click_on "Team 1"
    click_on "Weekly Surveys"
    choose "1", :id => :answer1_1
    choose "1", :id => :answer2_1
    choose "1", :id => :answer3_1
    choose "1", :id => :answer4_1
    click_on "Save"   
    assert_text "Successfully submitted weekly survey."
  end
    
  test "should be redirect to user dashboard after submitting a survey" do
    login(@user)
    click_on "Team 1"
    click_on "Weekly Surveys"
    choose "1", :id => :answer1_1
    choose "1", :id => :answer2_1
    choose "1", :id => :answer3_1
    choose "1", :id => :answer4_1
    click_on "Save"   
    assert_text "Welcome #{@user.first_name}"
  end

  test "should redirect manager to manager dashboard when trying to visit weekly survey" do
    login(@manager)
    visit weekly_surveys_path(@team, "dashboard")
    assert_text "Welcome #{@manager.first_name}"
    assert_text "You do not have permission to respond to surveys."
  end
   
  test "should redirect user to user dashboard when trying to visit another team's weekly survey" do
    team_without_user = Team.create(name: "Team Test")
    login(@user)
    visit weekly_surveys_path(team_without_user, "dashboard")
    assert_text "You do not have permission to respond to another team's survey."
  end
    
  test "should redirect user to user dashboard when trying to submit another survey for the week" do
    login(@user)
    click_on "Team 1"
    click_on "Weekly Surveys"
    choose "1", :id => :answer1_1
    choose "1", :id => :answer2_1
    choose "1", :id => :answer3_1
    choose "1", :id => :answer4_1
    click_on "Save"   
    assert_text "Successfully submitted weekly survey."
    visit weekly_surveys_path(@team, "dashboard")
    assert_text "You have already submitted this week's survey."
  end
  
  test "should redirect user back to team dashboard without submitting the weekly survey" do
    login(@user)
    click_on "Team 1"
    click_on "Weekly Surveys"
    assert_text "Back to Team 1"
    click_on "Back to Team 1"
    assert_text "Team 1 Details"
  end
    
  test "can successfully view survey list as a manager" do
    visit login_path
      fill_in "watiam", with: @manager.watiam
      fill_in "password", with: @manager.password
      click_on "Login"
      visit team_health_details_path(id: @team.id, date: Date.new(2021,3,13), current_week: true)
    assert_text "Team 1 Surveys for Current Week" 
  end
    
  def login(user)
    visit login_path
    fill_in "watiam", with: user.watiam
    fill_in "password", with: user.password
    click_on "Login"  
  end
end
