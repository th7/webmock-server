require 'spec_helper'

describe 'PATCH' do
  it "root" do
    stub_server_request(:patch, '/')
      .to_return(body: 'stub body', status: 201, headers: { 'x-custom-header' => 'stub header'})

    patch '/'
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq('stub body')
    expect(last_response.headers['x-custom-header']).to eq('stub header')
  end

  it "path" do
    stub_server_request(:patch, '/test')
      .to_return(body: 'stub body', status: 201, headers: { 'x-custom-header' => 'stub header'})

    patch '/test'
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq('stub body')
    expect(last_response.headers['x-custom-header']).to eq('stub header')
  end

  it "query parameters" do
    stub_server_request(:patch, '/test')
      .with(query: hash_including(x: 'y'))
      .to_return(body: 'stub body', status: 201, headers: { 'x-custom-header' => 'stub header'})

    patch '/test?x=y'
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq('stub body')
    expect(last_response.headers['x-custom-header']).to eq('stub header')
  end
end
