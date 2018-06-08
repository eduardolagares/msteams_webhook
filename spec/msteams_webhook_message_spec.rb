RSpec.describe MsteamsWebhook::Message do
  
  
    context 'validate #as_json structure' do
        it "basic structure" do

            color = '#ff000'
            title = 'Title test'
            text = 'Text test'

            message = MsteamsWebhook::Message.new text, title
            message.set_color color

            hash = message.as_json
            hash_keys = hash.keys
            
            expect(hash_keys.include?(:title)).to be_truthy
            expect(hash[:title].to_s).to equal(title)
            expect(hash_keys.include?(:text)).to be_truthy
            expect(hash[:text]).to equal(text)
            expect(hash_keys.include?(:themeColor)).to be_truthy
            expect(hash[:themeColor]).to equal(color)
            
        end

        it "sections structure" do
            message = MsteamsWebhook::Message.new 'Text test', 'Title test'
            message.add_activity 'activity_text', 'activity_title', 'activity_image'
             
            hash = message.as_json

            expect(hash.keys.include?(:sections)).to be_truthy
            sections = hash[:sections]
            expect(sections.any?).to be_truthy
            expect((sections[0].keys & [:activityTitle, :activityText, :activityImage]).any?).to be_truthy
        end

        it "action structure" do
            message = MsteamsWebhook::Message.new 'Text test', 'Title test'
            message.add_action 'text', 'url'
            
            hash = message.as_json

            expect(hash.keys.include?(:potentialAction)).to be_truthy
            actions = hash[:potentialAction]
            expect(actions.any?).to be_truthy
            expect((actions[0].keys & [:name, :target, :@context, :@type]).any?).to be_truthy
        end
    end

end