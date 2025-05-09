class Admin::RoomsController < AdminApplicationController
  before_action :set_params, only: [:create, :update]
  before_action :set_room, only: [:edit, :update, :destroy]

  def index
    if params[:encrypted_params].present?
      begin
        decrypted_params = Rack::Utils.parse_nested_query(EncryptionHelper.decrypt(params[:encrypted_params]))
        params.merge!(decrypted_params)
      rescue => e
        Rails.logger.error "Error decrypting parameters: #{e.message}"
        flash[:error] = "Invalid parameters."
        redirect_to rooms_path and return
      end
    end

    # Build the base, filtered query.
    rooms_query = Room.order(:room_number)
    rooms_query = rooms_query.where('room_number LIKE ?', "%#{params[:room_number].strip}%") if params[:room_number].present?
    rooms_query = rooms_query.where(room_status: params[:room_status]) if params[:room_status].present?

    # For HTML, paginate the results.
    @rooms = rooms_query.page(params[:page]).per(10)

    respond_to do |format|
      format.html  # renders your index.html.erb for HTML requests
      format.pdf do
        # Pass the full, unpaginated filtered set to the PDF generator.
        pdf = RoomPdf.new(rooms_query)
        send_data pdf.render,
                  filename: "rooms.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(set_params)

    if @room.save
      redirect_to rooms_path, notice: 'Room was successfully created.'
    else
      redirect_to new_room_p ath, alert: 'Room was failed to be created.'
    end
  end

  def edit
  end

  def update
    if @room.update(set_params)
      redirect_to edit_room_path@room, notice: 'Room was successfully updated.'
    else
      render :edit, alert: 'Room failed to be updated.'
    end
  end

  def destroy
    if @room.destroy
      redirect_to rooms_path, notice: 'Room was successfully deleted.'
    else
      redirect_to rooms_path, alert: 'Room failed to be deleted.'
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def set_params
    params.require(:room).permit(:room_status, :room_number)
  end
end