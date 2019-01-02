class Product
  attr_reader :name,
              :weight,
              :piece_flag,
              :search_flag,
              :proteins,
              :carbs,
              :calories,
              :fats,
              :double_info_flag,
              :weight_per_piece

  attr_accessor :search_flag, :piece_flag, :double_info_flag
  def initialize attributes={}
    @name = attributes[:name]
    @weight = attributes[:weight]
    @proteins = attributes[:proteins]
    @fats = attributes[:fats]
    @carbs = attributes[:carbs]
    @calories = attributes[:calories]
    @weight_per_piece = attributes[:weight_per_piece]
    @piece_flag = attributes[:piece_flag] || false
    @search_flag = attributes[:search_flag] || false
  end

  def searched?
    search_flag
  end

  def piece?
    piece_flag
  end

  def to_hash
    {
      name: name,
      weight: weight,
      piece_flag: piece_flag,
      search_flag: search_flag,
      proteins: proteins,
      fats: fats,
      carbs: carbs,
      calories: calories,
      weight_per_piece: weight_per_piece
    }
  end
end