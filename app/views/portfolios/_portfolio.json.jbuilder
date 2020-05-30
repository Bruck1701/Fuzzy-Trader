json.extract! portfolio, :id, :user_id, :totalInv, :currentVal, :cryptoAssets, :shareAssets, :totalAssets, :created_at, :updated_at
json.url portfolio_url(portfolio, format: :json)
