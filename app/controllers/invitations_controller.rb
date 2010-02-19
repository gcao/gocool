class InvitationsController < ApplicationController
  before_filter :login_check

  def index
    @invitations = Invitation.mine
  end

  def new
  end

  def create
    @invitees = params["invitation"]["invitees"]
    @start_side = params["invitation"]["start_side"]
    @note = params["invitation"]["note"]

    invitees, unrecognized = Invitation.parse_invitees(@invitees)

    attrs = params[:invitation].merge(:invitees => invitees.to_json).merge(:inviter_id => @current_user.id)
    @invitation = Invitation.new(attrs)

    if unrecognized.blank? and @invitation.valid?
      @invitation.save!
      redirect_to :action => :index
    else
      # show error
      render 'new'
    end
  end

  def show
  end
end
