class InvitationsController < ApplicationController
  before_filter :login_check

  def index
    @invitations_to_me = Invitation.to_me
    @invitations_by_me = Invitation.by_me
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
      @errors = []
      @errors << ["invitation_invitees", t('invitations.user_not_found').gsub('USERNAME', unrecognized.join(", "))]
      render 'new'
    end
  end

  def show
  end

  def accept
    invitation = Invitation.find(:id)
    if invitation
      invitation.accept
      render :text => "SUCCESS"
    else
      render :text => "NOT_FOUND"
    end
  end

  def reject
    invitation = Invitation.find(:id)
    if invitation
      invitation.reject
      render :text => "SUCCESS"
    else
      render :text => "NOT_FOUND"
    end
  end

  def cancel
    invitation = Invitation.find(:id)
    if invitation
      invitation.cancel
      render :text => "SUCCESS"
    else
      render :text => "NOT_FOUND"
    end
  end
end
