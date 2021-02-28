defmodule Tips.SpeakerTest do
  use ExUnit.Case
  alias Tips.Speaker

  setup context do
    pid = Kernel.spawn(Speaker, :speak, [])
    response = send(pid, context[:message])
    {:ok, [response: response]}
  end

  @tag message: {:say, "Hello"}
  test ".speak with context map", context do
    assert context[:response] == {:say, "Hello"}
  end

  @tag message: {:say, "Hello"}
  test ".speak with map matching", %{response: response} do
    assert response == {:say, "Hello"}
  end

  test ".speak with capture io" do
    test_process = self()

    pid =
      spawn(fn ->
        Process.group_leader(self(), test_process)
        Speaker.speak()
      end)

    send(pid, {:say, "Hello"})

    assert_receive {
      :io_request,
      _,
      _,
      {:put_chars, :unicode, "Hello\n"}
    }

    Process.exit(pid, :kill)
  end
end
