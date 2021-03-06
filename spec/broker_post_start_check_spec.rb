# Copyright (C) 2016-Present Pivotal Software, Inc. All rights reserved.
# This program and the accompanying materials are made available under the terms of the under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

require 'spec_helper'

RSpec.describe 'broker-post-start script' do
  let(:renderer) do
    merged_context = BoshEmulator.director_merge(YAML.load_file(manifest_file), 'broker')

    Bosh::Template::Renderer.new(context: merged_context.to_json)
  end

  let(:rendered_template) { renderer.render('jobs/broker/templates/post-start.erb') }

  context 'when the broker credentials contain special characters' do
    let(:manifest_file) { 'spec/fixtures/valid-with-special-characters.yml' }

    it 'escapes the broker username' do
      expect(rendered_template).to include "-brokerUsername '%username'\\''\"t:%!'"
    end

    it 'escapes the broker password' do
      expect(rendered_template).to include "-brokerPassword '%password'\\''\"t:%!'"
    end
  end
end
