require "spec_helper"

describe ActiveJobStatus do
  describe '.store' do
    it 'raises error when store has not set' do
      expect { ActiveJobStatus.store }.to raise_error(ActiveJobStatus::NoStoreError)
    end

    context 'when store has set' do
      let(:store) { new_store }

      before do
        ActiveJobStatus.store = store
      end

      it 'returns configured store' do
        expect { ActiveJobStatus.store }.to_not raise_error
        expect(ActiveJobStatus.store).to eq store
      end
    end
  end
end
