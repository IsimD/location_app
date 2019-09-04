require "rails_helper"

RSpec.describe Areas::Validators::Coordinates do
  subject { described_class.new(param).call }

  let(:invalid_params_error) { Areas::Validators::Coordinates::InvalidParamsError }
  let(:param) do
    {
      geometry: {
        coordinates: coordinates,
        type: type,
      },
    }.as_json
  end

  let(:type) { "Polygon" }

  let(:coordinates) do
    [
      [
        [
          7.36083984375,
          50.666872321810715,
        ],
        [
          8.76708984375,
          51.52241608253253,
        ],
        [
          9.76708984375,
          52.52241608253253,
        ],
        [
          7.36083984375,
          50.666872321810715,
        ],
      ],
    ]
  end

  context "valid params" do
    it "return nil" do
      expect(subject).to be(nil)
    end
  end

  context "invalid type" do
    let(:type) { "Point" }
    let(:expected_message) do
      "Invalid feature type, Only Polygon is supported"
    end

    it "raise an error with correct message" do
      expect { subject }.to raise_error(invalid_params_error, expected_message)
    end
  end

  context "with less than 4 points" do
    let(:expected_message) do
      "Each area must have at least 4 points"
    end
    let(:coordinates) do
      [
        [
          [
            7.36083984375,
            50.666872321810715,
          ],
          [
            9.76708984375,
            52.52241608253253,
          ],
          [
            7.36083984375,
            50.666872321810715,
          ],
        ],
      ]
    end

    it "raise an error with correct message" do
      expect { subject }.to raise_error(invalid_params_error, expected_message)
    end
  end

  context "with last point different than first" do
    let(:expected_message) do
      "The first point must be the same as the last"
    end
    let(:coordinates) do
      [
        [
          [
            1.36083984375,
            50.666872321810715,
          ],
          [
            8.76708984375,
            51.52241608253253,
          ],
          [
            9.76708984375,
            52.52241608253253,
          ],
          [
            7.36083984375,
            50.666872321810715,
          ],
        ],
      ]
    end

    it "raise an error with correct message" do
      expect { subject }.to raise_error(invalid_params_error, expected_message)
    end
  end

  context "without present params" do
    let(:expected_message) do
      "Coordinates can't be empty"
    end
    let(:coordinates) do
      [
      ]
    end

    it "raise an error with correct message" do
      expect { subject }.to raise_error(invalid_params_error, expected_message)
    end
  end

  context "with points different than numeric" do
    let(:expected_message) do
      "All points must be numeric"
    end
    let(:coordinates) do
      [
        [
          [
            7.36083984375,
            50.666872321810715,
          ],
          [
            "aaa123",
            51.52241608253253,
          ],
          [
            9.76708984375,
            52.52241608253253,
          ],
          [
            7.36083984375,
            50.666872321810715,
          ],
        ],
      ]
    end

    it "raise an error with correct message" do
      expect { subject }.to raise_error(invalid_params_error, expected_message)
    end
  end

  context "with longitude higher that 180" do
    let(:expected_message) do
      "Each longitude must be between -180 and 180"
    end
    let(:coordinates) do
      [
        [
          [
            7.36083984375,
            50.666872321810715,
          ],
          [
            200.0,
            51.52241608253253,
          ],
          [
            9.76708984375,
            52.52241608253253,
          ],
          [
            7.36083984375,
            50.666872321810715,
          ],
        ],
      ]
    end

    it "raise an error with correct message" do
      expect { subject }.to raise_error(invalid_params_error, expected_message)
    end
  end

  context "with latitude higher that 180" do
    let(:expected_message) do
      "Each latitude must be beetwon -90 and 90"
    end
    let(:coordinates) do
      [
        [
          [
            7.36083984375,
            50.666872321810715,
          ],
          [
            51.52241608253253,
            100.0,
          ],
          [
            9.76708984375,
            52.52241608253253,
          ],
          [
            7.36083984375,
            50.666872321810715,
          ],
        ],
      ]
    end

    it "raise an error with correct message" do
      expect { subject }.to raise_error(invalid_params_error, expected_message)
    end
  end
end
