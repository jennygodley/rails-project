# require 'unirest'

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
    @word = current_user.words.build(word_params)
    # @word = Word.new(word_params)

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
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://wordsapiv1.p.rapidapi.com/words/?random=true")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'wordsapiv1.p.rapidapi.com'
    request["x-rapidapi-key"] = ENV['RAPID_API_KEY']

    response = http.request(request)

    render json: response.read_body
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def word_params
      params.require(:word).permit(:word)
    end
end
