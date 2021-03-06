class BooksController < ApplicationController

  get '/books' do
    if logged_in?
      @books = current_user.books
      erb :'/books/index'
    else
      redirect '/'
    end
  end

  get '/books/new' do
    if logged_in?
      erb :'/books/new'
    else
      redirect '/'
    end
  end

  post '/books' do
    @user = current_user
    if logged_in?
      if !params[:title].empty? && !params[:author_name].empty?
          @book = Book.find_or_create_by(title: params[:title], author_name: params[:author_name])
          @author = Author.find_or_create_by(name: params[:author_name])
          if !@user.books.include?(@book)
            @book.author = @author
            @user.books << @book
            @book.save
            
            redirect "/books/#{@book.id}"
          else
            flash[:message] = "You have already have this book in your collection."
            redirect "/books/#{@book.id}"
          end
      else
        if params[:title].blank? && params[:author_name].blank?
          flash[:error] = 'Title and author cannot be blank'
        elsif params[:title].blank?
          flash[:error] = 'Title cannot be blank'
        else
          flash[:error] = "Author cannot be blank"
        end
        redirect '/books/new'
      end
    else
      redirect '/'
    end
  end

  get '/books/:id' do
    @book = Book.find_by_id(params[:id])
    @booknote = Booknote.find_by(book_id: @book.id)
    if current_user.booknotes.include?(@booknote)
      redirect "/booknotes/#{@booknote.id}"
    else
      erb :'books/show'
    end
  end

  get '/books/:id/edit' do
    @book = Book.find_by(id: params[:id])
    if logged_in? && current_user.books.include?(@book)
      erb :'/books/edit'
    else
      redirect '/'
    end
  end

  patch '/books/:id' do
    @book = Book.find_by(id: params[:id])
    @author = Author.find_by(name: @book.author.name)

    if logged_in? && current_user.books.include?(@book)
      if !params[:title].blank? && !params[:author_name].blank?
        @book.update(title: params[:title], author_name: params[:author_name])
        @author.update(name: params[:author_name])
        redirect "/books/#{@book.id}"
      else
        if params[:title].blank? && params[:author_name].blank?
          flash[:error] = 'Title and author cannot be blank'
        elsif params[:title].blank?
          flash[:error] = 'Title cannot be blank'
        else
          flash[:error] = "Author cannot be blank"
        end
        redirect "/books/#{@book.id}/edit"
      end
    end

  end

  delete '/books/:id/delete' do

    @book = Book.find_by(id: params[:id])
    if logged_in? && current_user.books.include?(@book)
      @book.destroy
    end
    redirect '/'
  end

  get '/books/:id/add' do
    @book = Book.find_by(id: params[:id])
    # @copy = Book.new(title: @book.title, author_name: @book.author_name)
    current_user.books << @book
    redirect '/'
  end

end
