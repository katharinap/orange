module ApplicationHelper
  def main_menu_links
    [
      [exercises_path, 'Exercises', 'bar-chart'],
      [courses_path, 'Classes', 'calendar'],
      [weights_path, 'Weight', 'line-chart'],
      # rubocop:disable Metrics/LineLength
      [user_push_up_challenge_entries_path(current_user), '100 Push-Ups', 'list-ul']
      # rubocop:enable Metrics/LineLength
    ]
  end

  def sigma
    '&Sigma;'.html_safe
  end
end
