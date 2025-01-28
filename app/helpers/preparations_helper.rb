module PreparationsHelper
  def preparation_dish_name(preparation)
    preparation.dish&.name || "No dish associated with this preparation."
  end
end
