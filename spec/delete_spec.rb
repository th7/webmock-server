require 'spec_helper'

describe 'DELETE' do
  it "root" do
    stub_server_request(:delete, '/')
      .to_return(body: 'stub body', status: 201, headers: { 'x-custom-header' => 'stub header'})

    delete '/'
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq('stub body')
    expect(last_response.headers['x-custom-header']).to eq('stub header')
  end

  it "path" do
    stub_server_request(:delete, '/test')
      .to_return(body: 'stub body', status: 201, headers: { 'x-custom-header' => 'stub header'})

    delete '/test'
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq('stub body')
    expect(last_response.headers['x-custom-header']).to eq('stub header')
  end

  it "query parameters" do
    stub_server_request(:delete, '/test')
      .with(query: hash_including(x: 'y'))
      .to_return(body: 'stub body', status: 201, headers: { 'x-custom-header' => 'stub header'})

    delete '/test?x=y'
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq('stub body')
    expect(last_response.headers['x-custom-header']).to eq('stub header')
  end
end
