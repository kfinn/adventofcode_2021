class Page
  def self.from_file(file)
    input_dots = []
    folds = []

    file_part = :dots

    file.each_line do |line|
      if line.blank?
        puts 'switching to folds'
        file_part = :folds
      elsif file_part == :dots
        input_dots << Dot.from_string(line)
      else
        folds << Fold.from_string(line)
      end
    end

    new(input_dots: input_dots, folds: folds)
  end

  attr_reader :input_dots, :folds

  def initialize(input_dots:, folds:)
    @input_dots = input_dots
    @folds = folds
  end

  def folded_dots
    @folded_dots ||= input_dots.each_with_object(Set.new) do |input_dot, folded_dots|
      folded_dots << folds.first.apply(input_dot)
    end
  end
end
