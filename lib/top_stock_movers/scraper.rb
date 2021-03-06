class TopStockMovers::Scraper


  def self.scrape_tradingview(category)
    doc = Nokogiri::HTML(open("https://www.tradingview.com/markets/stocks-usa/market-movers-#{category}/"))

    doc.css('body div div#js-category-content div div div div#js-screener-container div table tbody tr').each do |row|

      stock = TopStockMovers::Stocks.new
      stock.url = "https://www.tradingview.com#{row.css('a').attr('href').value}"

      stock_info = row.css('td').collect{|td| td.text}

      stock.ticker_symbol = stock_info[0].split("\n\t\t\t\t\t\t").reject{|c| c.empty?}[0]
      stock.name = stock_info[0].split("\n\t\t\t\t\t\t").reject{|c| c.empty?}[1].gsub(/INC|LTD|PLC|3X|LLC|BOND|SPONSORED|\s{2,}|[,(-]/, "++").split("++")[0]
      stock.price = stock_info[1].to_f
      stock.percent_change = stock_info[2].to_f
      stock.change = stock_info[3].to_f
      stock.rating = stock_info[4]
      stock.volume = stock_info[5].to_f
      stock.market_cap = stock_info[6].to_f.round(1)
      stock.sector = stock_info[10]
      stock.category = category
    end
  end
end
