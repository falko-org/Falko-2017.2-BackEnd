require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      "name": "Ronaldo",
      "email": "ronaldofenomeno@gmail.com",
      "password": "123456789",
      "password_confirmation": "123456789"
    )

    @second_user = User.create(
      "name": "Fernando",
      "email": "fernando@gmail.com",
      "password": "123456",
      "password_confirmation": "123456"
    )

    @project = Project.create(
      "name": "Falko",
      "description": "Some project description 1.",
      "user_id": @user.id,
      "is_project_from_github": true,
      "github_slug": "alaxalves/Falko",
      "is_scoring": false
    )

    @project2 = Project.create(
      "name": "Falko",
      "description": "Some project description 2.",
      "user_id": @user.id,
      "is_project_from_github": false,
      "github_slug": "alaxalves/LabBancos",
      "is_scoring": false
    )

    @token = AuthenticateUser.call(@user.email, @user.password)
    @second_token = AuthenticateUser.call(@second_user.email, @second_user.password)
  end

  test "should create project" do
      post "/users/#{@user.id}/projects", params: {
        "project": {
          "name": "Falko",
          "description": "Some project description.",
          "user_id": @user.id,
          "is_project_from_github": true,
          "is_scoring": false
        }
      }, headers: { Authorization: @token.result }

      assert_response :created
    end

  test "should not create project with invalid parameters" do
      @old_count = Project.count

      post "/users/#{@user.id}/projects", params: {
        "project": {
          "name": "",
          "description": "A" * 260,
          "is_project_from_github": true
        }
      }, headers: { Authorization: @token.result }

      assert_response :unprocessable_entity
      assert_equal @old_count, Project.count
    end

  test "should show project" do
    get "/projects/#{@project.id}", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should not to show another user projects" do
    get "/projects/#{@project.id}", headers: { Authorization: @second_token.result }
    assert_response :unauthorized
  end

  test "should update project" do
      @old_name = @project.name
      @old_description = @project.description

      patch "/projects/#{@project.id}", params: {
        project: {
          "name": "Falko BackEnd",
          "description": "Falko BackEnd!",
          "is_project_from_github": "true"
        }
      }, headers: { Authorization: @token.result }
      @project.reload

      assert_not_equal @old_name, @project.name
      assert_not_equal @old_description, @project.description
      assert_response :success
    end

  test "should not update project with invalid parameters" do
      @old_name = @project.name
      @old_description = @project.description

      patch "/projects/#{@project.id}", params: {
        project: {
          "name": "a",
          "description": "a",
          "is_project_from_github": "false"
        }
      }, headers: { Authorization: @token.result }
      @project.reload

      assert_response :unprocessable_entity
      assert_equal @old_name, @project.name
      assert_equal @old_description, @project.description
    end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete "/projects/#{@project.id}", headers: { Authorization: @token.result }
    end

    assert_response 204
  end

  test "should see repositories if user is logged in" do
    mock = Minitest::Mock.new

    def mock.get_github_user()
      [ Sawyer::Resource.new(Sawyer::Agent.new("/project_test"), login: "username") ]
    end

    def mock.get_github_repos(user_login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/project_test"), name: "repository_name") ]
    end

    def mock.get_github_orgs(user_login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/project_test"), name: "organization_name") ]
    end

    def mock.get_github_orgs_repos(org)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/project_test"), name: "organization_repository") ]
    end

    Adapter::GitHubProject.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :success
    end
  end

  test "should not see repositories if user email is wrong" do
    @token = AuthenticateUser.call("wrongtest@test.com", @user.password)

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Adapter::GitHubProject.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user password is wrong" do
    @token = AuthenticateUser.call(@user.email, "wrongtest")

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Adapter::GitHubProject.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user password and email are wrong" do
    @token = AuthenticateUser.call("wrongtest2@test.com", "wrongtest")

    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Adapter::GitHubProject.stub :new, mock do
      get "/repos", headers: { Authorization: @token.result }

      assert_response :unauthorized
    end
  end

  test "should not see repositories if user token is wrong" do
    mock = Minitest::Mock.new
    def mock.repositories
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test") ]
    end

    def mock.organizations
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "test") ]
    end

    def mock.organization_repositories(login)
      [ Sawyer::Resource.new(Sawyer::Agent.new("/test"), name: "test1") ]
    end

    Adapter::GitHubProject.stub :new, mock do
      get "/repos", headers: { Authorization: "aVeryFuckedUpToken-NoWayThisIsRight" }

      assert_response :unauthorized
    end
  end

  test "should not import a project from github if the is_project_from_github is invalid" do
    post "/users/#{@user.id}/projects", params: {
      "project": {
        "name": "Falko",
        "description": "Some project description.",
        "user_id": @user.id
      }
    }, headers: { Authorization: @token.result }

    assert_response :unprocessable_entity
  end

  test "should get contributors" do
    mock = Minitest::Mock.new

    def mock.get_contributors(github_slug)
      [
        Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "MatheusRich"),
        Sawyer::Resource.new(Sawyer::Agent.new("/test"), login: "ThalissonMelo")
      ]
    end

    Adapter::GitHubProject.stub :new, mock do
      get "/projects/#{@project.id}/contributors", headers: { Authorization: @token.result }
    end

    assert_response :ok
    assert_equal response.parsed_body, ["MatheusRich", "ThalissonMelo"]
  end

  test "should not get contributors with invalid repository" do
    get "/projects/-1/contributors", headers: { Authorization: @token.result }

    assert_response :not_found
  end
end
