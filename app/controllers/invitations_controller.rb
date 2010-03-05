class InvitationsController < ApplicationController
  before_filter :login_required
  skip_filter :admin_required, :only => [:update]

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

  def update
    if params[:accept]
      redirect_to :action => :accept
    elsif params[:reject]
      redirect_to :action => :reject
    elsif params[:cancel]
      redirect_to :action => :cancel
    else
      redirect_to :action => :show
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
      redirect_to game_url(invitation.game)
    else
      flash.now[:warn] = t('invitations.not_found')
      redirect_to :action => :index
    end
  end

  def reject
    invitation = Invitation.find(params[:id])
    if invitation
      invitation.reject
      invitation.save!
    else
      flash.now[:warn] = t('invitations.not_found')
    end
    redirect_to :action => :index
  end

  def cancel
    invitation = Invitation.find(params[:id])
    if invitation
      invitation.cancel
      invitation.save!
    else
      flash.now[:warn] = t('invitations.not_found')
    end
    redirect_to :action => :index
  end
end
