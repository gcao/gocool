class InvitationsController < ApplicationController
  before_filter :login_required

  def index
    @invitations_to_me = Invitation.active.to_me
    @invitations_by_me = Invitation.active.by_me
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
    @invitation = Invitation.find(params[:id])
    if @invitation.state == 'rejected'
      flash.now[:error] = t('invitations.rejected')
    elsif @invitation.state == 'accepted'
      flash.now[:success] = t('invitations.accepted').sub('GAME_URL', game_url(@invitation.game_id))
    elsif @invitation.state == 'canceled'
      flash.now[:error] = t('invitations.canceled')
    elsif @invitation.state == 'expired'
      flash.now[:error] = t('invitations.expired')
    else
      flash.now[:notice] = t('invitations.pending')
    end
  end

  def accept
    invitation = Invitation.find(params[:id])
    if invitation
      invitation.accept
      invitation.save!
      render :text => "SUCCESS"
    else
      render :text => "NOT_FOUND"
    end
  end

  def reject
    invitation = Invitation.find(params[:id])
    if invitation
      invitation.reject
      invitation.save!
      render :text => "SUCCESS"
    else
      render :text => "NOT_FOUND"
    end
  end

  def cancel
    invitation = Invitation.find(params[:id])
    if invitation
      invitation.cancel
      invitation.save!
      render :text => "SUCCESS"
    else
      render :text => "NOT_FOUND"
    end
  end
end
