# frozen_string_literal: true

# Smart computer picks the best possible move
# Uses minimax algorithm
class SmartComputer < Player
  def initialize(player_mark, player_color)
    super
    @player_name = 'AI'
    @other_mark = @player_mark == 'X' ? 'O' : 'X'
    @possible_moves = *(1..9)
  end

  def make_move!(occupied_move, positions, board, win_values = [-1, 1])
    unless occupied_move
      @possible_moves.delete(1)
      return super(1, positions, board)
    end
    @possible_moves.delete(occupied_move)
    best_move(@possible_moves, positions, win_values, -Float::INFINITY, Float::INFINITY)
    @possible_moves.delete(@best_move)
    super(@best_move, positions, board)
  end

  private

  include Board

  def best_move(possible_moves, positions, win_values, alpha, beta)
    best_score = -Float::INFINITY
    possible_moves.each do |possible_move|
      positions[possible_move - 1] = @player_mark
      score = minimax(possible_moves - [possible_move], positions, false, win_values, alpha, beta)
      positions[possible_move - 1] = ''
      (best_score = score) && (@best_move = possible_move) if score > best_score
      alpha = [best_score, alpha].max
      break if alpha >= beta
    end
  end

  def minimax(possible_moves, positions, is_maximizing, win_values, alpha, beta)
    result = check_winner(win_values, positions)
    return result if result

    if is_maximizing
      maximize(possible_moves, positions, win_values, alpha, beta)
    else
      minimize(possible_moves, positions, win_values, alpha, beta)
    end
  end

  def maximize(possible_moves, positions, win_values, alpha, beta)
    best_score = -Float::INFINITY
    possible_moves.each do |possible_move|
      positions[possible_move - 1] = @player_mark
      score = minimax(possible_moves - [possible_move], positions, false, win_values, alpha, beta)
      positions[possible_move - 1] = ''
      best_score = [score, best_score].max
      alpha = [best_score, alpha].max
      break if alpha >= beta
    end
    best_score
  end

  def minimize(possible_moves, positions, win_values, alpha, beta)
    best_score = Float::INFINITY
    possible_moves.each do |possible_move|
      positions[possible_move - 1] = @other_mark
      score = minimax(possible_moves - [possible_move], positions, true, win_values, alpha, beta)
      positions[possible_move - 1] = ''
      best_score = [score, best_score].min
      beta = [best_score, beta].min
      break if alpha >= beta
    end
    best_score
  end
end
