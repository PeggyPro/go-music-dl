package core

import "testing"

func TestAlbumFactoriesAndSourceList(t *testing.T) {
	supported := []string{"netease", "qq", "kugou", "kuwo"}
	for _, source := range supported {
		if fn := GetAlbumSearchFunc(source); fn == nil {
			t.Fatalf("GetAlbumSearchFunc(%q) returned nil", source)
		}
		if fn := GetAlbumDetailFunc(source); fn == nil {
			t.Fatalf("GetAlbumDetailFunc(%q) returned nil", source)
		}
		if fn := GetParseAlbumFunc(source); fn == nil {
			t.Fatalf("GetParseAlbumFunc(%q) returned nil", source)
		}
	}

	if got := GetAlbumSourceNames(); len(got) != len(supported) {
		t.Fatalf("GetAlbumSourceNames() returned %d sources, want %d", len(got), len(supported))
	}
}

func TestGetOriginalLinkSupportsAlbums(t *testing.T) {
	tests := []struct {
		source string
		id     string
		want   string
	}{
		{source: "netease", id: "123", want: "https://music.163.com/#/album?id=123"},
		{source: "qq", id: "abc", want: "https://y.qq.com/n/ryqq/albumDetail/abc"},
		{source: "kugou", id: "456", want: "https://www.kugou.com/album/456.html"},
		{source: "kuwo", id: "789", want: "http://www.kuwo.cn/album_detail/789"},
	}

	for _, tt := range tests {
		if got := GetOriginalLink(tt.source, tt.id, "album"); got != tt.want {
			t.Fatalf("GetOriginalLink(%q, %q, album) = %q, want %q", tt.source, tt.id, got, tt.want)
		}
	}
}
