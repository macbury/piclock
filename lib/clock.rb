require 'bundler/setup'
require 'ncurses'
require 'artii'
# This is base class for clock
class Clock
  # Starts clock screen
  def initialize
    @font             = Artii::Base.new(font: 'banner3') # banner3
    @background_color = Ncurses::COLOR_BLACK
  end

  # Starts render loop for clock ui
  def run
    init_ncurses

    while true
      render
      sleep 1
    end
  end

  # Cleans clock screen
  def close
    Ncurses.curs_set(1)
    Ncurses.endwin
  end

  private

  def init_ncurses
    Ncurses.initscr
    Ncurses.noecho
    Ncurses.cbreak
    Ncurses.nonl
    Ncurses.nodelay(Ncurses::stdscr, TRUE)
    Ncurses.curs_set(0)

    if Ncurses::has_colors?
      Ncurses::start_color
      Ncurses::use_default_colors
    end
  end

  # Returns formatted time
  # @return [String]
  def formatted_current_time
    Time.now.strftime('%H : %M')
  end

  # This renders all ui
  def render
    ascii_art_time = @font.asciify(formatted_current_time).split("\n")
    start_y        = Ncurses.LINES / 2 - ascii_art_time.size / 2
    start_x        = Ncurses.COLS / 2  - ascii_art_time[0].size / 2
    y              = 0

    ascii_art_time.each_with_index do |line, offset_y|
      Ncurses.mvaddstr(start_y + offset_y, start_x, line)
    end

    Ncurses.move(0, 0)
    Ncurses.refresh
  end
end
