require 'application_system_test_case'

class ActivationsTest < ApplicationSystemTestCase
  setup do
    @activation = activations(:one)
  end

  test 'visiting the index' do
    visit activations_url
    assert_selector 'h1', text: 'Activations'
  end

  test 'creating a Activation' do
    visit activations_url
    click_on 'New Activation'

    fill_in 'Code', with: @activation.code
    fill_in 'Device info', with: @activation.device_info
    click_on 'Create Activation'

    assert_text 'Activation was successfully created'
    click_on 'Back'
  end

  test 'updating a Activation' do
    visit activations_url
    click_on 'Edit', match: :first

    fill_in 'Code', with: @activation.code
    fill_in 'Device info', with: @activation.device_info
    click_on 'Update Activation'

    assert_text 'Activation was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Activation' do
    visit activations_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Activation was successfully destroyed'
  end
end
