def stock_picker(list)
    profit = 0
    best_buy_day = 0
    best_sell_day = 0
    list.each_with_index do |buy_price, buy_day|
        list[(buy_day + 1)..-1].each_with_index do |sell_price, sell_day|
            if sell_price - buy_price > profit
                profit = sell_price - buy_price
                best_buy_day = buy_day
                best_sell_day = sell_day + buy_day + 1
            end
        end
    end
    [best_buy_day, best_sell_day]
end

p stock_picker([12, 3, 12, 3, 123, 1, 12312, 23, 22])