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

  SCORES_BY_AUTOCOMPLETE_SUGGESTION_CHARACTER = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
  }

  def initialize(char_array)
    @char_array = char_array
  end

  attr_reader :char_array

  def corrupted?
    first_corrupted_character.present?
  end

  def incomplete?
    autocomplete_suggestion.any?
  end

  def score
    if corrupted?
      SCORES_BY_FIRST_CORRUPTED_CHARACTER.fetch(first_corrupted_character, 0)
    else
      autocomplete_suggestion.reduce(0) do |partial_score, char|
        (partial_score * 5) + SCORES_BY_AUTOCOMPLETE_SUGGESTION_CHARACTER[char]
      end
    end
  end

  def first_corrupted_character
    process_if_necessary!
    @first_corrupted_character
  end

  def autocomplete_suggestion
    process_if_necessary!
    @autocomplete_suggestion
  end

  def process_if_necessary!
    return if instance_variable_defined?(:@processed)

    @first_corrupted_character = nil

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

    if @first_corrupted_character.nil?
      @autocomplete_suggestion = open_characters.reverse.map { |char| CLOSING_CHARACTERS_BY_OPENING_CHARACTER[char] }
    else
      @autocomplete_suggestion = []
    end

    @processed = true
  end
end
