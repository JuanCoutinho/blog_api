# app/controllers/api/v1/posts_controller.rb
module Api
  module V1
    class PostsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

      # Retorna todos os posts
      def index
        @posts = Post.all

        # Adicione a URL da imagem usando Active Storage
        posts_with_images = @posts.map do |post|
          post.as_json.merge({
            photo_url: post.photo.attached? ? url_for(post.photo) : nil
          })
        end

        render json: posts_with_images
      end

      # Retorna um post específico
      def show
        @post = Post.find(params[:id])
        render json: @post.as_json.merge({
          photo_url: @post.photo.attached? ? url_for(@post.photo) : nil
        })
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Post not found" }, status: :not_found
      end

      # Cria um novo post
      def create
        @post = Post.new(post_params)

        if @post.save
          render json: @post.as_json.merge({
            photo_url: @post.photo.attached? ? url_for(@post.photo) : nil
          }), status: :created
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      # Atualiza um post existente
      def update
        @post = Post.find(params[:id])

        if @post.update(post_params)
          render json: @post.as_json.merge({
            photo_url: @post.photo.attached? ? url_for(@post.photo) : nil
          }), status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Post not found" }, status: :not_found
      end

      # Exclui um post
      def destroy
        @post = Post.find(params[:id])
        @post.destroy
        render json: { message: "Post deleted successfully" }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Post not found" }, status: :not_found
      end

      private

      # Define os parâmetros permitidos
      def post_params
        params.require(:post).permit(:title, :body, :feeling, :photo)
      end
    end
  end
end
