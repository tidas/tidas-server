module Tidas
  module Utilities

    SERIALIZATION_FIELDS = [
      :platform,
      :data_to_sign,
      :timestamp,
      :data_hash,
      :signature,
      :public_key_data
    ]

    TEST_DATA_STRING = %{AAEAAAAAAQUAAAB0b2tlbgIIAAAArjLCVQAAAAADFAAAAOampSqv22ZcJqGA8NycnekorHaIBEYAAAAwRAIgR318ZQZ2lZqMCtOmNZJeqaeFM4CXRK1MoV4V2nJoRlACIBQp4Aujc2Ks8t9ouJn//pVOhUFjqXhZltKBbz/GoSC9BUEAAAAELRQfUdYVN0zMrWllimOc9phemEbyqizT2NmPmnAnHrQnE+oTP0CLVFOZjDLhLdyoawcmMT6VurgDCkU9HW9zIg==}
  end
end
