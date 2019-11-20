package org.bits.wilp;

import java.util.Objects;

public class Country {
    private int id;
    private String name;
    private String capital;
    private String continent;

    public Country(String name, String capital, String continent) {
        this.id = name.hashCode();
        this.name = name;
        this.capital = capital;
        this.continent = continent;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getCapital() {
        return capital;
    }

    public String getContinent() {
        return continent;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Country country = (Country) o;
        return name.equals(country.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }

    @Override
    public String toString() {
        return "Country{" +
                "name='" + name + '\'' +
                ", capital='" + capital + '\'' +
                ", continent='" + continent + '\'' +
                '}';
    }
}
