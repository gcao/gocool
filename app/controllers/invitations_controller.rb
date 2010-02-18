class InvitationsController < ApplicationController
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

    @invitation = Invitation.new(params[:invitation].merge(:invitees => invitees))

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
