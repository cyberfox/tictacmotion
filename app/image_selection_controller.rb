class ImageSelectionController < UITableViewController
  def numberOfSectionsInTableView(tv)
    1
  end

  def tableView(tv, numberOfRowsInSection:path)
    1
  end

  def tableView(tv, cellForRowAtIndexPath:path)
    @cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'XCell').tap do |cell|
      cell.textLabel.text = "Cool X images"
      cell.detailTextLabel.text = "Neat pictures"
      cell.image = UIImage.imageNamed 'x2.png'
    end
  end

  def sectionIndexTitlesForTableView(tv)
    ["Pick a graphic"]
  end
end
