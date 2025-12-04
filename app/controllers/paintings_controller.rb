class PaintingsController < ApplicationController
  @@paintings_count = 0  # ❌ RuboCop will complain about this

  def index
    @@paintings_count += 1
    @paintings = Painting.all
    render json: { paintings: @paintings, visits: @@paintings_count }
  end
end
