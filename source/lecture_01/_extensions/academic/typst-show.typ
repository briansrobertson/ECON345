#show: doc => conf(
  title: $if(title)$[$title$]$else$none$endif$,
  subtitle: $if(subtitle)$[$subtitle$]$else$none$endif$,
  author: $if(by-author)$[$for(by-author)$$by-author.name.literal$$sep$, $endfor$]$else$none$endif$,
  institute: $if(institute)$[$institute$]$else$none$endif$,
  email: $if(email)$[$email$]$else$none$endif$,
  date: $if(date)$[$date$]$else$none$endif$,
  lang: $if(lang)$$lang$$else$"en"$endif$,
  region: $if(region)$$region$$else$"US"$endif$,
  doc,
)
