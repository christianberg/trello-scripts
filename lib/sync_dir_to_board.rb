require 'trello'

class SyncDirToBoard
  def initialize(settings = {})
    Trello.configure do |config|
      config.developer_public_key = settings['auth']['key']
      config.member_token = settings['auth']['token']
    end

    @me = Trello::Member.find(settings['user'])
    @board = find_or_create_board(settings['board'])
    @default_list = settings['default_list']
    initialize_board(@board)
  end

  def find_or_create_board(name)
    matching_boards = @me.boards.select { |b| b.name == name }
    if matching_boards.empty?
      Trello::Board.create(name: name)
    else
      matching_boards.first
    end
  end

  # Only if the board contains no cards at all, remove all lists. This
  # is used to remove the default lists from a newly created board.
  def initialize_board(board)
    return unless board.cards.empty?
    board.lists.each(&:close!)
  end

  def run!
  end
end
