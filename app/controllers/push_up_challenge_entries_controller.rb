class PushUpChallengeEntriesController < ApplicationController
  def index
    @user = current_user
    @entries = @user.push_up_challenge_entries.order(:week, :day)
    @editable_entry = @entries.detect { |entry| !entry.done_at }
  end

  def create
    PushUpChallengeEntry.create(entry_params)
    redirect_to user_push_up_challenge_entries_path(current_user)
  end

  def update
    entry = PushUpChallengeEntry.find(params[:id])
    ok = entry.update(entry_params)
    flash[:error] = 'Update failed' unless ok
    redirect_to user_push_up_challenge_entries_path(current_user)
  end

  def destroy
    entry = PushUpChallengeEntry.find(params[:id])
    entry.destroy
    flash[:info] = 'Entry deleted'
    redirect_to user_push_up_challenge_entries_path(current_user)
  end

  private

  def entry_params
    params.require(:push_up_challenge_entry)
          .permit(:week, :day, :user_id, :done_at, sets: [])
  end
end
