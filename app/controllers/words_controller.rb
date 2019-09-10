class WordsController < ProtectedController
  before_action :set_word, only: [:show, :update, :destroy]

  # GET /words
  def index
    @words = current_user.words

    render json: @words
  end

  # GET /words/1
  def show
    render json: @word
  end

  # POST /words
  def create
    @word = Word.new(word_params)

    if @word.save
      render json: @word, status: :created, location: @word
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /words/1
  def update
    if @word.update(word_params)
      render json: @word
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  # DELETE /words/1
  def destroy
    @word.destroy
  end

  def random
    @words = current_user.words
    @sample = @words.sample

    render json: @sample
  end

  def rapidapikey
    @key = ENV['RAPID_API_KEY']
    @response = { "key": @key }

    render json: @response
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def word_params
      params.require(:word).permit(:word, :user_id)
    end
end
