class UserStocksController < ApplicationController

  def index   
    ticker_symbol = params[:ticker]
    stock_data = Alphavantage::TimeSeries.new(symbol: ticker_symbol).quote
    @stock = Alphavantage::TimeSeries.search(keywords: ticker_symbol)

    stock_name = @stock[0].name

    if Stock.find_by(ticker: ticker_symbol) == nil
      stock = Stock.create(ticker: ticker_symbol, name: stock_name, last_price: stock_data.previous_close) 
      stock.users << User.find_by(id: params[:user])
    else
      stock = Stock.find_by(ticker: ticker_symbol)
      stock.users << User.find_by(id: params[:user])
    end
    redirect_to '/my_portfolio' , allow_other_host: true   
  end

  def show
    redirect_to '/my_portfolio' , allow_other_host: true   
  end

  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
       stock = Stock.new_lookup(params[:ticker])
       stock.save
    end  
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    redirect_to my_portfolio_path
  end


  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:notice] = "#{stock.ticker} was successfully removed from portfolio"
    redirect_to my_portfolio_path
  end
end
