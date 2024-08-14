require_relative "../lib/game"

describe Game do
  subject(:game) { described_class.new }

  describe "#verify_target_field_reachable?" do
    context "when piece_to_move is a Knight" do
      let(:knight) { Knight.new(0) }
      let(:knight_indexes) { [6, 7] }

      context "when target_field is reachable" do
        let(:knight_target_field) { "f6" }
        it "returns true" do
          return_value = game.verify_target_field_reachable?(knight, knight_indexes, knight_target_field)
          expect(return_value).to eq true
        end
      end

      context "when target_field NOT reachable" do
        let(:knight_target_field) { "f5" }
        it "returns false" do
          return_value = game.verify_target_field_reachable?(knight, knight_indexes, knight_target_field)
          expect(return_value).to eq false
        end
      end
    end

    context "when piece_to_move is a Bishop" do
      let(:bishop) { Bishop.new(0) }
      let(:bishop_indexes) { [5, 7] }

      context "when target_field is reachable" do
        let(:bishop_target_field) { "d6" }
        it "returns true" do
          return_value = game.verify_target_field_reachable?(bishop, bishop_indexes, bishop_target_field)
          expect(return_value).to eq true
        end
      end

      context "when target_field NOT reachable" do
        let(:bishop_target_field) { "e5" }
        it "returns false" do
          return_value = game.verify_target_field_reachable?(bishop, bishop_indexes, bishop_target_field)
          expect(return_value).to eq false
        end
      end
    end

    context "when piece_to_move is a King" do
      let(:king) { King.new(0) }
      let(:king_indexes) { [4, 7] }
      context "when target_field is reachable" do
        let(:king_target_field) { "e7" }
        it "returns true" do
          return_value = game.verify_target_field_reachable?(king, king_indexes, king_target_field)
          expect(return_value).to eq true
        end
      end

      context "when target_field NOT reachable" do
        let(:king_target_field) { "e8" }
        it "returns false" do
          return_value = game.verify_target_field_reachable?(king, king_indexes, king_target_field)
          expect(return_value).to eq false
        end
      end
    end

    context "when piece_to_move is a Queen" do
      let(:queen) { Queen.new(0) }
      let(:queen_indexes) { [3, 7] }
      context "when target_field is reachable" do
        let(:queen_target_field) { "h4" }
        it "returns true" do
          return_value = game.verify_target_field_reachable?(queen, queen_indexes, queen_target_field)
          expect(return_value).to eq true
        end
      end

      context "when target_field NOT reachable" do
        let(:queen_target_field) { "e3" }
        it "returns false" do
          return_value = game.verify_target_field_reachable?(queen, queen_indexes, queen_target_field)
          expect(return_value).to eq false
        end
      end
    end

    context "when piece_to_move is a Pawn" do
      let(:pawn) { Pawn.new(0) }
      let(:pawn_indexes) { [7, 6] }
      context "when target_field is a reachable vertix in the PawnGraph" do
        let(:pawn_target_field) { "h5" }
        it "returns true" do
          allow(game).to receive(:reachable_in_graph_of_current_player?).and_return(true)
          allow(game).to receive(:diagonal_move_possible?).and_return(false)
          return_value = game.verify_target_field_reachable?(pawn, pawn_indexes, pawn_target_field)
          expect(return_value).to eq true
        end
      end

      context "when target_field is a diagonal field with piece of opponent" do
        let(:pawn_target_field) { "g6" }
        it "returns true" do
          allow(game).to receive(:reachable_in_graph_of_current_player?).and_return(false)
          allow(game).to receive(:diagonal_move_possible?).and_return(true)
          return_value = game.verify_target_field_reachable?(pawn, pawn_indexes, pawn_target_field)
          expect(return_value).to eq true
        end
      end

      context "when target_field NOT reachable" do
        let(:pawn_target_field) { "h5" }
        it "returns false" do
          allow(game).to receive(:reachable_in_graph_of_current_player?).and_return(false)
          allow(game).to receive(:diagonal_move_possible?).and_return(false)
          return_value = game.verify_target_field_reachable?(pawn, pawn_indexes, pawn_target_field)
          expect(return_value).to eq false
        end
      end
    end
  end

  describe "#diagonal_move_possible?" do
    let(:pawn) { Pawn.new(0) }
    let(:pawn_indexes) { [7, 6] }
    let(:target_indexes) { [6, 5] }

    context "when target field is diagonal field and contains piece of opponent" do
      it "returns true" do
        allow(game).to receive(:calculate_diagonal_indexes).and_return([[6, 5]])
        opponent_set = game.player2.instance_variable_set(:@set, [King.new(0)])
        game.board[target_indexes[0]][target_indexes[1]] = opponent_set[0]

        return_value = game.diagonal_move_possible?(pawn, pawn_indexes, target_indexes)
        expect(return_value).to eq true
      end
    end

    context "when target field is not a diagonal field" do
      it "returns nil" do
        allow(game).to receive(:calculate_diagonal_indexes).and_return([[6, 4]])

        return_value = game.diagonal_move_possible?(pawn, pawn_indexes, target_indexes)
        expect(return_value).to eq nil
      end
    end

    context "when target field is diagonal field and does not contain piece of opponent" do
      it "returns false" do
        allow(game).to receive(:calculate_diagonal_indexes).and_return([[6, 5]])

        return_value = game.diagonal_move_possible?(pawn, pawn_indexes, target_indexes)
        expect(return_value).to eq false
      end
    end
  end
end
