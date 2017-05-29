class ImageSelectionController < UITableViewController
  TOGGLE = {'x' => ['x.png', 'x2.png'].map {|x| UIImage.imageNamed x}, 'o' => ['o.png', 'o2.png'].map {|x| UIImage.imageNamed x}}

  def numberOfSectionsInTableView(tv)
    1
  end

  def tableView(tv, numberOfRowsInSection:section)
    section == 0 ? 2 : 0
  end

  def tableView(tv, cellForRowAtIndexPath:path)
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:"XCell#{path.row}").tap do |cell|
      cell.textLabel.text = "Cool X images"
      cell.detailTextLabel.text = "Neat pictures"
      cell.image = TOGGLE['x'][path.row]
    end
  end

  def tableView(tv, titleForHeaderInSection: section)
    "Pick a graphic"
  end
end
