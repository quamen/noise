# Copyright 2009 Clear Interactive. All rights reserved.

class Notifier
  def notify(title, message)
    # Abstract method.
    raise NotImplementedError
  end
end
