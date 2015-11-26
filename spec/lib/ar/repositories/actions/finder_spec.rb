require 'spec_helper'

describe Arpa::Repositories::Actions::Finder, type: :repository, slow: true do

  let(:resource_record)   { create :repository_resource, :user }
  let(:action_record_001) { create :repository_action, :index, resource: resource_record }
  let(:action_record_002) { create :repository_action, :show, resource: resource_record}

  before do
    action_record_001
    action_record_002
  end

  describe '#by_name_and_resource' do

    context 'when exist with the params' do

      let(:result) { subject.by_name_and_resource('index', resource_record) }

      it 'should return a resource with name "index"' do
        expect(result.name).to eql 'index'
      end

      it 'the result should be an instance of Arpa::Entities::Action' do
        expect(result).to be_an Arpa::Entities::Action
      end
    end

    context 'when nonexist with the params' do

      let(:result) { subject.by_name_and_resource('nonexist_action', resource_record) }

      it 'the result should return nil' do
        expect(result).to be_nil
      end
    end

  end

  describe 'getting permissions from profile_ids' do
    let(:profile_001) { create :repository_profile, :with_complete_association, name: 'prof_001' }
    let(:profile_002) { create :repository_profile, :with_complete_association, name: 'prof_002' }
    let(:profile_ids) { [profile_001.id, profile_002.id] }

    let(:result) { subject.permissions(profile_ids) }
    let(:first)  { result.first }

    it 'should return an Arpa::Entities::Permissions' do
      expect(result).to be_an Arpa::Entities::Permissions
    end

    it 'should has just one permission' do
      expect(result.permissions.size).to be == 1
    end

  end

end
