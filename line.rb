class Line
  CLOSING_CHARACTERS_BY_OPENING_CHARACTER = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }

  SCORES_BY_FIRST_CORRUPTED_CHARACTER = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
  }

  def initialize(char_array)
    @char_array = char_array
  end

  attr_reader :char_array

  def corrupted?
    first_corrupted_character.present?
  end

  def score
    SCORES_BY_FIRST_CORRUPTED_CHARACTER.fetch(first_corrupted_character, 0)
  end


  def first_corrupted_character
    unless instance_variable_defined?(:@first_corrupted_character)
      open_characters = []
      char_array.each do |char|
        if CLOSING_CHARACTERS_BY_OPENING_CHARACTER.include? char
          open_characters.push char
        elsif char == CLOSING_CHARACTERS_BY_OPENING_CHARACTER[open_characters.last]
          open_characters.pop
        else
          @first_corrupted_character = char
          break
        end
      end
      @first_corrupted_character ||= nil
    end
    @first_corrupted_character
  end
end
