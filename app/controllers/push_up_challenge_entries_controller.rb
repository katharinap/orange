class PushUpChallengeEntriesController < ApplicationController
  def index
    @user = current_user
    entries = @user.push_up_challenge_entries.order(:week, :day)
    @entries_done, entries_to_do = entries.partition(&:done_at)
    @editable_entry = entries_to_do.first
    @today = today
    @entries_to_do = entries_to_do.drop(1)
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
          .permit(:week, :day, :rest, :user_id, :done_at, sets: [])
  end
end
