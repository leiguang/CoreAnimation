//插入话题
-(void)insertTopic:(NSString *)strDescription eventId:(NSNumber*)eId
{
  NSInteger tmpWordCount = _maxWord-_textView.text.length;
  if (strDescription.length > tmpWordCount)
  {
      return;
  }
  LJTextViewBinding *topicBinding = [[LJTextViewBinding alloc]initWithTopicName:strDescription topicId:eId];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = textlineSpacing;// 字体的行间距
  NSAttributedString *topicAttributedString = [[NSAttributedString alloc] initWithString:strDescription
                                                                              attributes: @{NSForegroundColorAttributeName : UIColorFromRGB(0x0bbe06),NSFontAttributeName : [UIFont systemFontOfSize:16], NSParagraphStyleAttributeName : paragraphStyle,LJTextBindingAttributeName:topicBinding}];
  
  NSRange selectedRange = self.textView.selectedRange;
  NSRange rangeTopic = NSMakeRange(selectedRange.location,strDescription.length);
  NSMutableAttributedString *attributedString = self.textView.attributedText.mutableCopy;
  
  if (self.isUserPutIn)//如果用户输入#号，然后选择话题列表，先要删除前面的#号
  {
      [attributedString deleteCharactersInRange:NSMakeRange(selectedRange.location-1, 1)];
      selectedRange = NSMakeRange(selectedRange.location-1, selectedRange.length);
      rangeTopic = NSMakeRange(rangeTopic.location-1,strDescription.length);
      self.isUserPutIn = NO;
  }
  // 插入到当前选中位置.
  [attributedString replaceCharactersInRange:selectedRange
                        withAttributedString:topicAttributedString];
  
  // 设置富文本会导致 textView 的 font 变为另一种富文本默认字体,因此需要专门指定字体为原先字体.
  [attributedString addAttribute:NSFontAttributeName
                           value:FONT(16)
                           range:(NSRange){0,attributedString.length}];
  
  self.textView.attributedText = attributedString;
  self.textView.selectedRange = NSMakeRange(selectedRange.location+strDescription.length, 0);
  [_textView setTypingAttributes:textAttrDict];
  [self textViewDidChange:_textView];
}


//得到用户输入的话题数组
- (NSArray *)getTopicRangeArray:(NSAttributedString *)attributedString {
   NSAttributedString *traveAStr = attributedString ?: _textView.attributedText;
   __block NSMutableArray *rangeArray = [NSMutableArray array];

   [[self topicExpression] enumerateMatchesInString:traveAStr.string
                                 options:0
                                   range:NSMakeRange(0, traveAStr.string.length)
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  NSRange resultRange = result.range;
                                  NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:NULL];
                                  if (attributedDict[QYPPTextBindingAttributeName])
                                  {
                                      LJTextViewBinding *binding = attributedDict[QYPPTextBindingAttributeName];
                                      binding.rangePosition = NSStringFromRange(resultRange);
                                      if (binding)
                                      {
                                          [rangeArray addObject:binding];
                                      }

                                  }
                              }];
   return rangeArray;

作者：陆号
链接：https://www.jianshu.com/p/9e43b4cbc117
來源：简书
简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。