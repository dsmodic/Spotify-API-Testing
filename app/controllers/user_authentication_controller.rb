class UserAuthenticationController < ApplicationController
  # Uncomment this if you want to force users to sign in before any other actions
  skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

  def sign_in_form
    render({ :template => "user_authentication/sign_in.html.erb" })
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email").downcase }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def sign_up_form
    render({ :template => "user_authentication/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email").downcase
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.first_name = params.fetch("query_first_name").titleize
    @user.last_name = params.fetch("query_last_name").titleize
    @user.user_name = params.fetch("query_user_name").downcase
    @user.received_follow_requests_count = 0
    @user.sent_follow_requests_count = 0

    save_status = @user.save

    if save_status == true
      session[:user_id] = @user.id
   
      redirect_to("/", { :notice => "User account created successfully."})
    else
      redirect_to("/user_sign_up", { :alert => "User account failed to create successfully."})
    end
  end
    
  def edit_profile_form
    render({ :template => "user_authentication/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    @user.email = params.fetch("query_email").downcase
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.first_name = params.fetch("query_first_name").titleize
    @user.last_name = params.fetch("query_last_name").titleize
    @user.user_name = params.fetch("query_user_name").downcase
    #@user.received_follow_requests_count = params.fetch("query_received_follow_requests_count")
    #@user.sent_follow_requests_count = params.fetch("query_sent_follow_requests_count")
    
    if @user.valid?
      @user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      render({ :template => "user_authentication/edit_profile_with_errors.html.erb" })
    end
  end

  def destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled" })
  end

  def user_index
    
    @followed_users = @current_user.follows.order(last_name: "asc")
    follow_ids = @followed_users.pluck(:recipient_id)
    follow_ids = follow_ids.push(@current_user.id)
    @non_followed_users = User.all.where.not(id: follow_ids).order(last_name:"asc")

    render({:template => "/user_authentication/user_index.html.erb"})
  end

  def user_likes
    the_id = params.fetch("path_id")
    
    render({:template => "/likes/user_likes.html.erb"})

  end
 
end
