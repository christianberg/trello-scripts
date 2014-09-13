require 'trello'

class SyncDirToBoard

  def initialize(settings = {})
    Trello.configure do |config|
      config.developer_public_key = settings['auth']['key']
      config.member_token = settings['auth']['token']
    end

    @me = Trello::Member.find(settings['user'])
    @board = find_or_create_board(settings['board'])
  end

  def find_or_create_board(name)
    matching_boards = @me.boards.select { |b| b.name == name }
    if matching_boards.empty?
      puts "#{name} not found"
      Trello::Board.create(name: name)
    else
      puts 'board found: ' + matching_boards.first.id
      matching_boards.first
    end
  end

  def run!
  end

end
