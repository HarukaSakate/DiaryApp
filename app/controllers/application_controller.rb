class DiariesController < ApplicationController
    def index
        @diaries = Diary.all.order(date: :desc)

    # 検索機能
        if params[:search].present?
            @diaries = @diaries.where('title LIKE ? OR body LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
        end

    # タグフィルタリング
        if params[:tag].present?
            @diaries = @diaries.where('tags LIKE ?', "%#{params[:tag]}%")
        end

    # 並び替え
        if params[:sort].present?
            @diaries = @diaries.order(params[:sort])
        end
    end

    def show
        @diary = Diary.find(params[:id])
    end

    def new
        @diary = Diary.new
    end

    def create
        @diary = Diary.new(diary_params)
        if @diary.save
            redirect_to @diary
        else
            render :new
        end
    end

    def edit
        @diary = Diary.find(params[:id])
    end

    def update
        @diary = Diary.find(params[:id])
        if @diary.update(diary_params)
            redirect_to @diary
        else
            render :edit
        end
    end

    def destroy
        @diary = Diary.find(params[:id])
        @diary.destroy
        redirect_to diaries_path
    end

    private

    def diary_params
        params.require(:diary).permit(:title, :body, :date, :tags)
    end
end

class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    end
end

class DiariesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        @diaries = Diary.where(user: current_user).order(date: :desc)
    end

    def create
        @diary = current_user.diaries.build(diary_params)
        if @diary.save
            redirect_to @diary
        else
            render :new
        end
    end
end
