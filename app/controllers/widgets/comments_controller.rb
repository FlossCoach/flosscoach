class Widgets::CommentsController < WidgetsController
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :set_widget, only: [:show, :update, :create]
  skip_before_filter :verify_authenticity_token, only: [:update]
  before_action :authorize

  # GET /users
  def index
    if params[:without_replies]
      @comments = @widget.comments.is_not_replies
    else
      @comments = @widget.comments
    end
  end

  # GET /users/1
  def show
    redirect_to comment.widget.project
  end

  # POST /users
  def create
    @comment = WidgetComment.new(comment_params)
    @comment.user = current_user
    @comment.widget = @widget
    @widget.comments << @comment
    @comment.project_id = @widget.project.id

    if comment_params[:reply_to_id]
      comment_dad = WidgetComment.find(comment_params[:reply_to_id])
      comment_dad.replies << @comment
    end

    respond_to do |format|
    if @comment.save
      flash.now[:notice] = "Comment was successfully saved."
        format.js
        format.html
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    if @widget.update_attributes(widget_params)
      respond_to do |format|
        format.json { render :json => { :status => 'Ok', :message => 'Received'}, :status => 200 }
      end
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
     id = @comment.project_id 
    @comment.destroy
    redirect_to project_path(id), notice: 'Comment was successfully destroyed.'
  end

  private


  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:widget_comment).permit!
  end

  def set_comment
    @comment = WidgetComment.find(params[:id])
  end
  def set_widget
    @widget = Widget.find(params[:widget_id])
  end



end
